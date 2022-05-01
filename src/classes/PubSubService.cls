/**
 * @description A simple Pub/Sub pattern implementation
 */
public with sharing class PubSubService {

    private static final String IMPLEMENTATION_PARAM = 'implementation';
    private static final String CHANNEL_PARAM = 'channel';

    private Map<String, List<IHandleMessages>> channelMap = new Map<String, List<IHandleMessages>>();

    private PubSubService() { }

    /**
     * @description A singleton for service interaction.
     */
    public static PubSubService Instance {
        get {
            if (Instance == null) {
                Instance = new PubSubService();
            }

            return Instance;
        }

        private set;
    }

    /**
     * @description Subscribes a given IHandleMessages implementation to the channels it returns.
     * @param implementation An instance of IHandleMessages.
     * @throws ArgumentNullException if implementation is null.
     */
    public void subscribe(IHandleMessages implementation) {

        ArgumentNullException.throwIfNull(implementation, IMPLEMENTATION_PARAM);

        List<String> subscriberChannels = implementation.getSubscribedChannels();
        for (String subChannel : subscriberChannels){
            List<IHandleMessages> handlerList = channelMap.get(subChannel);
            if (handlerList == null){
                handlerList = new List<IHandleMessages>();
            }
            handlerList.add(implementation);
            channelMap.put(subChannel,handlerList);
        }
    }

    /**
     * @description Un-subscribes a given IHandleMessages implementation to the channels it returns.
     * @param implementation An instance of IHandleMessages.
     * @throws ArgumentNullException if implementation is null.
     */
    public void unsubscribe(IHandleMessages implementation) {
        ArgumentNullException.throwIfNull(implementation, IMPLEMENTATION_PARAM);

        List<String> subscriberChannels = implementation.getSubscribedChannels();
        for (String subChannel : subscriberChannels){
            channelMap.remove(subChannel);
        }
    }

    /**
     * @description Emits a message to a given channel containing the specified data.
     * @param channel The channel to emit a message on.
     * @param data The data to emit.
     * @throws ArgumentNullException if channel is null.
     */
    public void emit(String channel, Object data) {

        ArgumentNullException.throwIfNull(channel, CHANNEL_PARAM);

        if (channelMap.containsKey(channel)){
            List<IHandleMessages> subscribers = channelMap.get(channel);
            for (IHandleMessages subscriber : subscribers){
                subscriber.handleMessage(channel,data);
            }

        }

    }
}