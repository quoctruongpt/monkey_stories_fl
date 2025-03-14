# UnityServices

```
// UnityBridge.ts
import {RefObject} from 'react';

import {UnityGameObject, UnityMethodName} from '@/constants';
import {OnMessageHandler, TMessageUnity, TResultFromRN} from '@/types';
import {generateId} from '@/utils';

type TMessagePromise = {
  resolve: (value: any) => void;
  reject: (reason?: any) => void;
  timeoutId?: NodeJS.Timeout;
};

type TMessageQueue = {
  [key: string]: TMessagePromise;
};

export class UnityBridge {
  private unityRef: RefObject<any>;
  private onMessageHandler: OnMessageHandler;
  private messageQueue: TMessageQueue = {};
  private readonly TIMEOUT_DURATION = 30000; // 30 seconds timeout

  constructor(unityRef: RefObject<any>, onMessageHandler: OnMessageHandler) {
    this.unityRef = unityRef;
    this.onMessageHandler = onMessageHandler;
  }

  // Hàm gửi message từ RN sang Unity
  sendMessageToUnity(params: TMessageUnity): void {
    try {
      const id = params.id ?? generateId();
      const message = JSON.stringify({...params, id});
      console.log('UnityBridge', '📤 Gửi message đến Unity', {...params, id});

      this.unityRef.current?.postMessage(
        UnityGameObject.REACT_NATIVE_BRIDGE,
        UnityMethodName.REQUEST_UNITY_ACTION,
        message,
      );
    } catch (error) {
      console.error(
        'sendMessageToUnity',
        'Error sending message to Unity:',
        error,
      );
    }
  }

  returnToUnity(params: TResultFromRN): void {
    try {
      this.unityRef.current?.postMessage(
        UnityGameObject.REACT_NATIVE_BRIDGE,
        UnityMethodName.RESULT_FROM_RN,
        JSON.stringify(params),
      );
      console.log('UnityBridge', '📤 Gửi result đến Unity', params);
    } catch (error) {
      console.error('UnityBridge', 'Error sending message to Unity:', error);
    }
  }

  // Gửi message đến Unity và đợi response
  sendMessageToUnityWithResponse(
    params: Omit<TMessageUnity, 'id'>,
  ): Promise<any> {
    return new Promise((resolve, reject) => {
      try {
        const id = generateId();
        const message = {...params, id} as TMessageUnity;

        // Tạo timeout handler
        const timeoutId = setTimeout(() => {
          if (this.messageQueue[id]) {
            const {reject: rejectCallback} = this.messageQueue[id];
            delete this.messageQueue[id];
            rejectCallback(new Error('Unity response timeout'));
          }
        }, this.TIMEOUT_DURATION);

        // Lưu promise handlers và timeout ID vào queue
        this.messageQueue[id] = {resolve, reject, timeoutId};

        // Gửi message đến Unity
        this.sendMessageToUnity(message);
      } catch (error) {
        reject(error);
      }
    });
  }

  // Hàm xử lý message nhận từ Unity và gửi response
  async handleUnityMessage(data: string): Promise<void> {
    let message: TMessageUnity;
    try {
      message = JSON.parse(data);
    } catch (parseError) {
      console.error('Error parsing message from Unity:', parseError);
      return;
    }

    try {
      const payload =
        typeof message.payload === 'string'
          ? JSON.parse(message.payload || '{}')
          : message.payload;

      // Kiểm tra xem có promise đang đợi response không
      if (message.id && this.messageQueue[message.id]) {
        console.log(
          'UnityBridge',
          `📥 Nhận result type ${message.type}-${message.id}`,
          {
            ...message,
            payload,
          },
        );
        const {resolve, reject, timeoutId} = this.messageQueue[message.id];

        // Clear timeout trước khi xử lý response
        if (timeoutId) {
          clearTimeout(timeoutId);
        }

        delete this.messageQueue[message.id];

        if (payload.status === 'success') {
          resolve(payload);
        } else {
          reject(payload);
        }
        return;
      }

      console.log('UnityBridge', '📥 Nhận message từ Unity', {
        ...message,
        payload,
      });
      const result = await this.onMessageHandler({...message, payload});

      // Nếu thành công, gửi response dạng resolve
      const response = {
        id: message.id,
        type: message.type,
        payload: {success: true, result},
      } as TResultFromRN;
      this.returnToUnity(response);
    } catch (error) {
      // Nếu có lỗi, gửi response dạng reject
      const response = {
        id: message.id,
        type: message.type,
        payload: {
          success: false,
          result: error instanceof Error ? error.message : error,
        },
      } as TResultFromRN;
      this.returnToUnity(response);
    }
  }
}

```

#UnityContainer

```
import UnityView from '@azesmway/react-native-unity';
import React, {
  useCallback,
  useEffect,
  useMemo,
  useRef,
  forwardRef,
  useImperativeHandle,
} from 'react';
import {Dimensions} from 'react-native';
import Orientation, {OrientationType} from 'react-native-orientation-locker';
import Animated, {
  useAnimatedStyle,
  useSharedValue,
  withTiming,
} from 'react-native-reanimated';

import {getOrientationType, onLockOrientation} from './UnityContainer.helper';
import {styles} from './UnityContainer.style';

import {EMessageTypeUN, EOrientationNavigationTypes} from '@/constants';
import {useUnity} from '@/contexts';
import {navigationRef} from '@/navigation';
import {UnityBridge} from '@/services/unity/UnityBridge';
import {TMessageUnity} from '@/types';

const {width, height} = Dimensions.get('screen');
const POSITION_HIDE = width + height;
const POSITION_SHOW = 0;
type TMessageFromUnity = {nativeEvent: {message: string}};

interface IUnityContainerProps {}
export interface UnityContainerRef {
  onSendMessage: (message: TMessageUnity) => void;
  onSendMessageWithResponse: (message: TMessageUnity) => Promise<any>;
}

/**
 * Component quản lý tích hợp và hiển thị Unity trong React Native
 * */

export const UnityContainer = forwardRef<
  UnityContainerRef,
  IUnityContainerProps
>((props, ref) => {
  // Khởi tạo ref cho UnityView (ban đầu sẽ là null, nhưng không ảnh hưởng vì ref là object ổn định)
  const unityRef = useRef(null);
  const currentOrientation = useRef<OrientationType>(OrientationType.PORTRAIT);
  const {isUnityVisible, onBusinessLogic} = useUnity();
  const position = useSharedValue(POSITION_HIDE);

  const stylez = useAnimatedStyle(() => ({
    transform: [{translateX: position.value}],
  }));

  const unityBridge = useMemo(
    () => new UnityBridge(unityRef, onBusinessLogic),
    [onBusinessLogic],
  );

  const handleUnityMessage = useCallback(
    ({nativeEvent}: TMessageFromUnity) => {
      unityBridge.handleUnityMessage(nativeEvent.message);
    },
    [unityBridge],
  );

  const handleSendMessage = useCallback(
    (message: TMessageUnity) => {
      unityBridge.sendMessageToUnity(message);
    },
    [unityBridge],
  );

  const handleSendMessageWithResponse = useCallback(
    (message: TMessageUnity) => {
      return unityBridge.sendMessageToUnityWithResponse(message);
    },
    [unityBridge],
  );

  useImperativeHandle(ref, () => ({
    onSendMessage: handleSendMessage,
    onSendMessageWithResponse: handleSendMessageWithResponse,
  }));

  // Điều chỉnh vị trí hiển thị của UnityView dựa theo trạng thái isUnityVisible
  useEffect(() => {
    position.value = withTiming(isUnityVisible ? POSITION_SHOW : POSITION_HIDE);
  }, [isUnityVisible]);

  // Lắng nghe thay đổi Orientation và các option của navigation
  useEffect(() => {
    const onOrientationOptionChanged = (
      orientation: EOrientationNavigationTypes,
    ) => {
      onLockOrientation(orientation);
    };

    const onOrientationChanged = (orientation: OrientationType) => {
      currentOrientation.current = orientation;
      const orientationUnity = getOrientationType(orientation);
      unityBridge.sendMessageToUnity({
        type: EMessageTypeUN.ORIENTATION,
        payload: {orientation: orientationUnity},
      });
    };

    const unsubscribe = navigationRef.addListener('options', ({data}) => {
      const options = data.options as any;
      onOrientationOptionChanged(options?.orientation);
    });

    Orientation.addLockListener(onOrientationChanged);

    return () => {
      unsubscribe();
      Orientation.removeLockListener(onOrientationChanged);
    };
  }, [unityBridge]);

  return (
    <Animated.View style={[styles.unityContainer, stylez]}>
      <UnityView
        ref={unityRef}
        style={styles.unityView}
        onUnityMessage={handleUnityMessage}
      />
    </Animated.View>
  );
});

```

#UnityContext

```
// UnityContext.js
import React, {
  createContext,
  useState,
  useContext,
  useCallback,
  useRef,
} from 'react';

import {TUnityContext, TUnityProvider} from './UnityContext.type';

import {UnityContainer, UnityContainerRef} from '@/components';
import {EMessageTypeUN} from '@/constants';
import {THandlerMessageUnity, TMessageUnity} from '@/types';

const UnityContext = createContext<TUnityContext>({
  isUnityVisible: false,
  showUnity: () => {},
  hideUnity: () => {},
  sendMessageToUnity: () => {},
  registerHandler: () => {},
  unregisterHandler: () => {},
  onBusinessLogic: async () => {},
  sendMessageToUnityWithResponse: async () => {},
});

export const UnityProvider = ({children}: TUnityProvider) => {
  const [isUnityVisible, setUnityVisible] = useState(false);
  const handlersRef = useRef<Record<EMessageTypeUN, THandlerMessageUnity>>({});
  const unityRef = useRef<UnityContainerRef>(null);

  const showUnity = () => setUnityVisible(true);
  const hideUnity = () => setUnityVisible(false);
  const sendMessageToUnity = (message: TMessageUnity): void => {
    try {
      unityRef.current?.onSendMessage(message);
    } catch (error) {
      console.error('Lỗi khi gửi message đến Unity:', error);
    }
  };

  const sendMessageToUnityWithResponse = async (message: TMessageUnity) => {
    try {
      return unityRef.current?.onSendMessageWithResponse(message);
    } catch (error) {
      console.error('Lỗi khi gửi message đến Unity:', error);
      throw error;
    }
  };

  // Đăng ký một handler cho một message type cụ thể
  const registerHandler = useCallback(
    (type: EMessageTypeUN, handler: THandlerMessageUnity): void => {
      handlersRef.current = {...handlersRef.current, [type]: handler};
    },
    [],
  );

  // Hủy đăng ký handler khi không cần thiết
  const unregisterHandler = useCallback((type: EMessageTypeUN): void => {
    const newHandlers = {...handlersRef.current};
    delete newHandlers[type];
    handlersRef.current = newHandlers;
  }, []);

  // Hàm xử lý được gọi khi UnityContainer gửi message
  const onBusinessLogic = useCallback(async (data: TMessageUnity) => {
    try {
      const handler = handlersRef.current[data.type];
      if (handler) {
        const result = await handler(data);
        return result;
      } else {
        // Nếu không có handler đăng ký từ màn hình, xử lý mặc định trong UnityProvider
        return handlerLogicDefaults(data);
      }
    } catch (error: any) {
      console.error('Lỗi trong onBusinessLogic:', error);
      throw new Error(`Lỗi xử lý message type ${data.type}: ${error.message}`);
    }
  }, []);

  const handlerLogicDefaults = useCallback((data: TMessageUnity) => {
    try {
      switch (data.type) {
        case EMessageTypeUN.USER:
          if (data.payload.action === 'get') {
            return {id: 1234, name: 'John Smith', avatar: ''};
          }
          return null;
        default:
          console.warn(
            'handlerLogicDefaults',
            `Không tìm thấy handler cho type ${data.type}`,
          );
          return null;
      }
    } catch (error) {
      console.error('Lỗi trong handlerLogicDefaults:', error);
      return null;
    }
  }, []);

  return (
    <UnityContext.Provider
      value={{
        isUnityVisible,
        showUnity,
        hideUnity,
        sendMessageToUnity,
        sendMessageToUnityWithResponse,
        registerHandler,
        unregisterHandler,
        onBusinessLogic,
      }}>
      {children}
      <UnityContainer ref={unityRef} />
    </UnityContext.Provider>
  );
};

// Hook để sử dụng context dễ dàng
export const useUnity = () => useContext(UnityContext);

```

# Màn cần dùng

```
import {useFocusEffect} from '@react-navigation/native';
import {useCallback, useEffect} from 'react';

import {EMessageTypeUN, OpenUnityDestination} from '@/constants';
import {useUnity} from '@/contexts';
import {useAppNavigation} from '@/hooks';

export function UnityScreen() {
  const navigation = useAppNavigation();

  const {
    showUnity,
    hideUnity,
    sendMessageToUnity,
    registerHandler,
    unregisterHandler,
  } = useUnity();

  useEffect(() => {
    sendMessageToUnity({
      type: EMessageTypeUN.OPEN_UNITY,
      payload: {destination: OpenUnityDestination.OPEN_MAP},
    });
  }, []);

  useEffect(() => {
    // Đăng ký handler cho loại message "LESSON_PRESS"
    registerHandler(EMessageTypeUN.CLOSE_UNITY, async () => {
      navigation.goBack();
      return null;
    });

    return () => {
      unregisterHandler(EMessageTypeUN.CLOSE_UNITY);
    };
  }, [registerHandler, unregisterHandler]);

  useFocusEffect(
    useCallback(() => {
      showUnity();

      return () => {
        hideUnity();
      };
    }, []),
  );

  return null;
}

```
