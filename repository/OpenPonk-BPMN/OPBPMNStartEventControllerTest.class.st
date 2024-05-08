Class {
	#name : 'OPBPMNStartEventControllerTest',
	#superclass : 'OPBPMNNodeControllerTest',
	#category : 'OpenPonk-BPMN-Tests',
	#package : 'OpenPonk-BPMN',
	#tag : 'Tests'
}

{ #category : 'accessing' }
OPBPMNStartEventControllerTest >> controllerClass [
	^ OPBPMNStartEventController 
]

{ #category : 'accessing' }
OPBPMNStartEventControllerTest >> diagramElementClass [
	^ OPBPMNStartEventShape 
]

{ #category : 'accessing' }
OPBPMNStartEventControllerTest >> modelClass [
	^ OPBPMNStartEventModel 
]

{ #category : 'accessing' }
OPBPMNStartEventControllerTest >> targetControllerClass [
	^ OPBPMNPoolController  
]

{ #category : 'accessing' }
OPBPMNStartEventControllerTest >> targetModelClass [
	^ OPBPMNPoolModel 
]
