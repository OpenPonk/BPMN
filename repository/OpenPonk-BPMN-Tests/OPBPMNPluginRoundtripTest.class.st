"
Verifies the serialization and deserialization roundtrip persistence for BPMN collaboration models.
"
Class {
	#name : 'OPBPMNPluginRoundtripTest',
	#superclass : 'OPAbstractPluginExampleRoundtripTest',
	#category : 'OpenPonk-BPMN-Tests-Plugin',
	#package : 'OpenPonk-BPMN-Tests',
	#tag : 'Plugin'
}

{ #category : 'accessing' }
OPBPMNPluginRoundtripTest class >> pluginClass [
	^ OPBPMNPlugin
]
