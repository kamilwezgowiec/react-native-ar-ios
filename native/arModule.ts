import { NativeModules, Platform } from "react-native";

type ShowFn = () => void;

class ARModule {
  public show(): void {
    Platform.select<ShowFn>({
      ios: NativeModules.RNARKit.show,
      default: () => undefined,
    })();
  }
}

export const arModule = new ARModule();
