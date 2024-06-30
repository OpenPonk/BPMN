Class {
	#name : 'OPBPMNIntermediateEventControllerTest',
	#superclass : 'OPBPMNNodeControllerTest',
	#category : 'OpenPonk-BPMN-Tests',
	#package : 'OpenPonk-BPMN',
	#tag : 'Tests'
}

{ #category : 'accessing' }
OPBPMNIntermediateEventControllerTest >> controllerClass [
	^ OPBPMNIntermediateEventController 
]

{ #category : 'accessing' }
OPBPMNIntermediateEventControllerTest >> creationTargetControllerClass [
	^ OPBPMNPoolController  
]

{ #category : 'accessing' }
OPBPMNIntermediateEventControllerTest >> creationTargetModelClass [
	^ OPBPMNPoolModel 
]

{ #category : 'accessing' }
OPBPMNIntermediateEventControllerTest >> diagramElementClass [
	^ OPBPMNIntermediateEventShape
]

{ #category : 'accessing' }
OPBPMNIntermediateEventControllerTest >> modelClass [
	^ OPBPMNIntermediateEventModel 
]
