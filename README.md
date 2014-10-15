#Event Enrichment Platform (EEP) Ruby Client

A ruby client library for sending and clearing Events via the [Event Enrichment Platform](http://www.eventenrichment.com) REST [API](http://support.eventenrichment.com/knowledge_base/topics/rest-api).

## Installation

The library is packaged as a gem that can be installed via the gem command line:

```
gem install eep_client
```

Or as a line in your Gemfile is using bundler:

``` ruby
gem 'eep_client'
```

## Usage

### Init

First, require the library and then create an instance of the client with your company's api_token.  You may also want to include the `EepClient::Const` module for proper Event severity and priority values:

``` ruby
require 'eep_client'

include EepClient::Const

ec = EepClient.new('your_company_api_token')
```

### Sending Events

Send events with the `send_event` method which takes a `Hash` of event attribute names and values.  This will return either an `EepClient::OkResponse` on success or an `EepClient::ErrorResponse` on error.  Attribute names are ruby symbols that map to the `JSON attr` column of the [EEP Common Event Format](http://support.eventenrichment.com/knowledge_base/topics/event-enrichment-common-event-format) table:

``` ruby
event = {
  :local_instance_id => 'abc123',
  :creation_time => '2014-10-13T18:00:00Z', # or an int for unix epoch or a ruby Time instance
  :severity => SEV_CRITICAL,
  :message => 'Uh oh, we have a problem',
  :event_class => 'Snafus',
  :source_location => 'some.host.com'
}

response = ec.send_event(event)

if response.is_a? EepClient::OkResponse
  puts "event created: status=#{response.status}, message=#{response.message}, event_id=#{response.id}"
else
 puts "error: status=#{response.status}, messages:"
 puts response.messages.join("\n")
end
```

### Clearing Events

Clear events with the `clear_event` method which takes a `Hash` consisting of the Event's `local_instance_id` and `source_location`.  This will return either an `EepClient::OkResponse` on success or an `EepClient::ErrorResponse` on error:

``` ruby
clear = {
  :local_instance_id => 'abc123',
  :source_location => 'some.host.com'
}

response = ec.send_clear(clear)

if response.is_a? EepClient::OkResponse
  puts "event cleared: status=#{response.status}, message=#{response.message}, event_id=#{response.id}"
else
 puts "error: status=#{response.status}, messages:"
 puts response.messages.join("\n")
end
```

### Exceptions

In the event that EEP is down or server infrastructure is in a bad state, `send_event` and `clear_event` may raise `Errno::ECONNREFUSED` or one of the `Net::HTTPServerError` subclasses indicating a 5xx HTTP error.


