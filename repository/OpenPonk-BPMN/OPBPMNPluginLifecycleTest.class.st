Class {
	#name : 'OPBPMNPluginLifecycleTest',
	#superclass : 'OPAbstractPluginExampleLifecycleTest',
	#category : 'OpenPonk-BPMN-Tests',
	#package : 'OpenPonk-BPMN',
	#tag : 'Tests'
}

{ #category : 'accessing' }
OPBPMNPluginLifecycleTest class >> pluginClass [
	"Answers the OPPlugin class under test."
	^ OPBPMNPlugin
]
