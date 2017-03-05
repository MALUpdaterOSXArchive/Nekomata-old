# Nekomata
![screenshot](http://i.imgur.com/tKeYxJ4.png)
Nekomata (猫又) is an open sourced AniList.co library manager.  In development, but basic functionality works.

Requires latest SDK (10.12) and XCode 8 or later to compile. Deployment target is 10.10.

## How to Compile in XCode
Warning: This won't work if you don't have a Developer ID installed. If you don't have one, obtain one by joining the Apple Developer Program or turn off code signing.

1. Get the Source
2. Copy ClientConstants-sample.m to ClientConstants.m. Copy your client id and secret key to the respective variables in ClientConstants.m. You can obtain an App Key [here](https://anilist.co/settings/developer/client/)
3. Type 'xcodebuild' to build

## Dependencies
All the frameworks are included. Just build! Here are the frameworks that are used in this app:

* Sparkle.framework
* MASPreferences.framework
* AFNetworking.framework
 
Licenses for these frameworks and related classes can be seen [here](https://github.com/Atelier-Shiori/Nekomata/wiki/Credits).

##License
Unless stated, Source code is licensed under New BSD License
