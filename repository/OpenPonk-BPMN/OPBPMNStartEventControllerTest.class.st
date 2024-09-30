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
OPBPMNStartEventControllerTest >> creationTargetControllerClass [
	^ OPBPMNPoolController  
]

{ #category : 'accessing' }
OPBPMNStartEventControllerTest >> creationTargetModelClass [
	^ OPBPMNPoolModel 
]

{ #category : 'accessing' }
OPBPMNStartEventControllerTest >> diagramElementClass [
	^ OPBPMNStartEventShape 
]

{ #category : 'accessing' }
OPBPMNStartEventControllerTest >> modelClass [
	^ OPBPMNStartEventModel 
]
