# Hipchat Bitcoin Ticker

This gets the bitcoin price from [bitcoinaverage](https://bitcoinaverage.com/) and posts it to a hipchat room at a specified interval.

### Usage

1. Clone this repo
2. Install the gems `bundle install`
3. Copy `.env.sample` to `.env` and tweak to taste
4. Run `foreman start` to start the ticker going

### Settings (in the .env)

1. `TIMING_INTERVAL` __(Optional)__ - In seconds, how often to tick... defaults to 60 seconds if not present
2. `HIPCHAT_TOKEN`   __(Required)__ - Your API v2 token
3. `HIPCHAT_ROOM`    __(Required)__ - The room name or id to post the messages too

### Deployment

You can use foreman to export a proper production deployment, via launchctl/upstart/etc

### License

Copyright (c) 2014 Rocketmade.com

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
