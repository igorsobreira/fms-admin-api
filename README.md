Flash Media Server Administration API ![Build status](https://secure.travis-ci.org/igorsobreira/fms-admin-api.png?branch=master)
=====================================

Command line interface to [Flash Media Server Administration API][fmsapi]:

Instalation
-----------

   $ gem install fms-admin-api

Usage
-----

    $ fmsapi <method_name> --host=<fms host> [other params]

Just pick a method from the [documentation][fmsapi] and replace convention 
from camelCase to underscore_case (same for the parameters)

Example:

    $ fmsapi reload_app --host=fms.example.com --auser=fms --apswd=secret --app_inst=live


Ruby client usage
-----------------

You can use the ruby client directly on you code:

```ruby
require 'fms'

client = FMS::Client.new(:host => 'fms.example.com',
                         :auser => 'fms',
                         :apswd => 'secret')  # you can use :port here, 1111 is default
```

now just call any method defined in the [FMS Admin API][fmsapi]:

```ruby
client.reload_app(:app_inst => 'live/cam1')
client.get_apps(:force => true, :verbose => true)
```

just note that the methods name and parameters are used with ruby_default_notation 
instead of camelCase as documented.

The return value from all api method calls is a `FMS::Response`, on which you may want to call `.to_xml` 
to get a `REXML::Document` instance:

```ruby
require 'rexml/xpath'

xml_resp = client.get_live_stream_stats(:app_inst => 'live', :stream => 'cam1').to_xml
puts REXML::XPath.first(xml_resp, '/result/data/publisher/name').text

```

there is also a `to_s` method on `FMS::Response`.

Take a look in the tests/ folder for more detailed specification.

[fmsapi]: http://help.adobe.com/en_US/flashmediaserver/adminapi/WSa4cb07693d12388431df580a12a34991ebc-8000.html