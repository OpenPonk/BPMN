"
Verifies ViewModel contracts across all bundled BPMN example templates.
"
Class {
	#name : 'OPBPMNPluginViewModelTest',
	#superclass : 'OPAbstractPluginExampleViewModelTest',
	#category : 'OpenPonk-BPMN-Tests-Plugin',
	#package : 'OpenPonk-BPMN-Tests',
	#tag : 'Plugin'
}

{ #category : 'accessing' }
OPBPMNPluginViewModelTest class >> pluginClass [

	^ OPBPMNPlugin
]
