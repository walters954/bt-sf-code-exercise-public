/**
 * @description An implementation of IHandleMessages which validates the passed in Lead and inserts it.
 */
public with sharing class IncomingLeadHandler implements IHandleMessages {
    @TestVisible private static final String INCOMING_LEAD_CHANNEL = 'IncomingLeads';
    @TestVisible private static final String INVALID_LEAD_ERROR = 'The Lead specified is invalid.';
    @TestVisible private static final String CHANNEL_PARAM = 'channel';
    @TestVisible private static final String DATA_PARAM = 'data';

    /**
     * @description Constructs an instance of IncomingLeadHandler.
     */
    public IncomingLeadHandler() { }

    /**
     * @description Handles a message on a subscribed channel.
     * @param channel The channel emitting the message.
     * @param data The accompanying data for the message.
     * @throws ArgumentNullException if channel is null.
     * @throws ArgumentException if the lead is missing a FirstName.
     */
    public void handleMessage(String channel, Object data) {

        //check for nulls inside of channel and throw ArgumentNullException
        ArgumentNullException.throwIfNull(channel, CHANNEL_PARAM);
        ArgumentNullException.throwIfNull(data, DATA_PARAM);
        //check if the record/object is what we are looking for
        //cannot use .getSObjectType().getDescribe().getName() because is of type Object and not sobject
        //after looking close at PubSubService I see there is an implementation of this interface I would have probably
        //only use instance of instead of doing the check for the param as a first attempt at this implementation
        if (!(data instanceof Lead)) {
            return;
        }

        Lead messageLead = (Lead)data;

        if (String.isBlank(messageLead.FirstName)){
            throw new ArgumentException(INVALID_LEAD_ERROR);
        }

        insert messageLead;


    }

    /**
     * @description Gets a list of channels an implementation subscribes to.
     * @return A List<String> of channel names this implementation is subscribed to.
     */
    public List<String> getSubscribedChannels() {

        List<String> subChannels = new List<String>();
        subChannels.add(INCOMING_LEAD_CHANNEL);
        return subChannels;
    }
}