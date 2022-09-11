//
//  MFBStreamHandler.swift
//  moke_flutter_beacon
//
//  Created by fkm on 2022/09/11.
//


class MFBStreamHandler: NSObject, FlutterStreamHandler {
    var eventSink: FlutterEventSink? = nil
    
    public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        eventSink = events
        return nil
    }
    
    public func onCancel(withArguments arguments: Any?) -> FlutterError? {
        eventSink = nil
        return nil
    }
}
