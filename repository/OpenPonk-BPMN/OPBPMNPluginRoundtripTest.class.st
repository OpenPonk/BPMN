"
Verifies the serialization and deserialization roundtrip persistence for BPMN collaboration models.
"
Class {
	#name : 'OPBPMNPluginRoundtripTest',
	#superclass : 'OPAbstractPluginExampleRoundtripTest',
	#category : 'OpenPonk-BPMN-Tests',
	#package : 'OpenPonk-BPMN',
	#tag : 'Tests'
}

{ #category : 'accessing' }
OPBPMNPluginRoundtripTest class >> pluginClass [
	^ OPBPMNPlugin
]
