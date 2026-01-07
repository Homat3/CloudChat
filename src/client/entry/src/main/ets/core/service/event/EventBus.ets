import { Event } from '../../tag/Event';

export class EventBus {
  private static eventBus: Map<Event, Array<Function>> = new Map();

  public static on(event: Event, listener: Function) {
    if (!EventBus.eventBus.has(event)) {
      EventBus.eventBus.set(event, new Array<Function>());
    }
    const funcList = EventBus.eventBus.get(event)
    if (funcList) {
      funcList.push(listener);
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