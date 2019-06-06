//
//  AudioService.swift
//  TickTask-macOS
//
//  Created by Joshua Grant on 6/6/19.
//  Copyright © 2019 joshgrant. All rights reserved.
//

import AudioToolbox

class AudioService
{
    static var defaultAudioHardwareID: UInt32 {
        var propAddr = AudioObjectPropertyAddress(
            mSelector: AudioObjectPropertySelector(kAudioHardwarePropertyDefaultOutputDevice),
            mScope: AudioObjectPropertyScope(kAudioObjectPropertyScopeGlobal),
            mElement: AudioObjectPropertyElement(kAudioObjectPropertyElementMaster))
        
        var defaultAudioHardwareID : AudioDeviceID = 0
        var size = UInt32(MemoryLayout<UInt32>.size)
        
        AudioHardwareServiceGetPropertyData(AudioObjectID(kAudioObjectSystemObject), &propAddr, 0 , nil, &size, &defaultAudioHardwareID)
        
        return defaultAudioHardwareID
    }
    
    static var isSystemMuted: Bool {
        var propAddr = AudioObjectPropertyAddress(
            mSelector: AudioObjectPropertySelector(kAudioDevicePropertyMute),
            mScope: AudioObjectPropertyScope(kAudioObjectPropertyScopeOutput),
            mElement: AudioObjectPropertyElement(kAudioObjectPropertyElementMaster))
        
        var isMuted: UInt32 = 0
        var size = UInt32(MemoryLayout<UInt32>.size)
        
        AudioHardwareServiceGetPropertyData(defaultAudioHardwareID, &propAddr, 0, nil, &size, &isMuted)
        
        return isMuted != 0
    }
}
