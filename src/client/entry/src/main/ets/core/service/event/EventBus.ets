import { Event } from '../../tag/Event';

export class EventBus {
  private static eventBus: Map<Event, Map<string, Function>> = new Map();

  public static on(event: Event, listenerId: string, listener: Function) {
    if (!EventBus.eventBus.has(event)) {
      EventBus.eventBus.set(event, new Map<string, Function>());
    }
    const funcList = EventBus.eventBus.get(event)
    if (funcList) {
      funcList.set(listenerId, listener);
    }
  }

  public static emit(event: Event, arg: (object | string | number | void)) {
    const listeners = EventBus.eventBus.get(event);
    if (listeners) {
      listeners.forEach((listener) => {
        listener(arg);
      });
    }
  }
}