"
Verifies the initialization, registration, and shutdown lifecycle of the BPMN plugin.
"
Class {
	#name : 'OPBPMNPluginLifecycleTest',
	#superclass : 'OPAbstractPluginExampleLifecycleTest',
	#category : 'OpenPonk-BPMN-Tests-Plugin',
	#package : 'OpenPonk-BPMN-Tests',
	#tag : 'Plugin'
}

{ #category : 'accessing' }
OPBPMNPluginLifecycleTest class >> pluginClass [
	"Answers the OPPlugin class under test."
	^ OPBPMNPlugin
]
