# FixProtocolTools

Provides fixless command which shows fix protocol log in human readable way.

Inspired by http://code.nomad-labs.com/fix-message-viewer/

Classic fix log:

    20111107-10:52:22.133: 8=FIX.4.49=10035=A34=149=XXX-MD52=20111107-10:52:22.12856=XXX-XUAT98=0108=30141=Y553=XXXmd554=XXXmd110=146
    20111107-10:52:25.272: 8=FIX.4.49=7735=A52=20111107-10:52:25.92649=XXX-XUAT56=XXX-MD34=1141=Y108=3098=010=176
    20111107-10:52:25.273: 8=FIX.4.49=7235=h52=20111107-10:52:25.92749=XXX-XUAT56=XXX-MD34=2336=MD340=210=000
    20111107-10:52:54.373: 8=FIX.4.49=13035=V34=349=XXX-MD52=20111107-10:52:54.37356=XXX-XUAT262=EURUSD:0:0001263=1264=0265=0146=155=EUR/USD267=2269=0269=110=192
    20111107-10:52:54.374: 8=FIX.4.49=13035=V34=449=XXX-MD52=20111107-10:52:54.37456=XXX-XUAT262=GBPUSD:0:0002263=1264=0265=0146=155=GBP/USD267=2269=0269=110=157
    20111107-10:52:54.688: 8=FIX.4.49=17335=W52=20111107-10:52:58.25549=XXX-XUAT56=XXX-MD34=6262=GBPUSD:0:000255=GBP/USD268=2269=0270=1.6006271=1000000299=28019269=1270=1.60082271=1000000299=2802010=207

Viewed by fixless:

           =-=-=-=-=-=-==-=-=-=-=-=-==-=-=-=-=-=-=
    BeginString                    =  FIX.4.4                               8  =  FIX.4.4
    BodyLength                     =  100                                   9  =  100
    MsgType                        =  Logon                               35  =  A
    MsgSeqNum                      =  1                                   34  =  1
    SenderCompID                   =  XXX-MD                              49  =  XXX-MD
    SendingTime                    =  20111107-10:52:22.128               52  =  20111107-10:52:22.128
    TargetCompID                   =  XXX-XUAT                            56  =  XXX-XUAT
    EncryptMethod                  =  NONE_OTHER                          98  =  0
    HeartBtInt                     =  30                                 108  =  30
    ResetSeqNumFlag                =  Y                                  141  =  Y
    Username                       =  XXXmd                              553  =  XXXmd
    Password                       =  XXXmd1                             554  =  XXXmd1
    CheckSum                       =  146                                 10  =  146
            =-=-=-=-=-=-==-=-=-=-=-=-==-=-=-=-=-=-=

## Installation

Add this line to your application's Gemfile:

    gem 'fix_protocol_tools'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install fix_protocol_tools

## Usage

fixless [options] [fixlogfile]

options are:
* -c -- color output
* -l -- use less command for output

