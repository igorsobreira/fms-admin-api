Flash Media Server Administration API
=====================================

Command line interface to [Flash Media Server Administration API][fmsapi]:

Don't use yet... contribute!
----------------------------

This project is under development, we plan to provide:

 * A client to FMS REST API in ruby
 * A command line interface

Client usage
------------

    require 'fms'

    client = FMS::Client.new(:host => 'fms.example.com',
                             :auser => 'fms',
                             :apswd => 'secret')  # you can use :port here, 1111 is default

now just call any method defined in the [API][fmsapi]:

    client.reload_app(:app_inst => 'live/cam1')
    client.get_apps(:force => true, :verbose => true)

just note that the methods name and parameters are used with ruby_default_notation 
instead of camelCase as documented.

Take a look in the tests/ folder for more detailed specification.

[fmsapi]: http://help.adobe.com/en_US/flashmediaserver/adminapi/WSa4cb07693d12388431df580a12a34991ebc-8000.html