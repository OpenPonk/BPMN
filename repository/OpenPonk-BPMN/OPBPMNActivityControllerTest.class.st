Class {
	#name : 'OPBPMNActivityControllerTest',
	#superclass : 'OPBPMNNodeControllerTest',
	#category : 'OpenPonk-BPMN-Tests',
	#package : 'OpenPonk-BPMN',
	#tag : 'Tests'
}

{ #category : 'accessing' }
OPBPMNActivityControllerTest >> controllerClass [
	^ OPBPMNActivityController 
]

{ #category : 'accessing' }
OPBPMNActivityControllerTest >> creationTargetControllerClass [
	^ OPBPMNPoolController  
]

{ #category : 'accessing' }
OPBPMNActivityControllerTest >> creationTargetModelClass [
	^ OPBPMNPoolModel 
]

{ #category : 'accessing' }
OPBPMNActivityControllerTest >> diagramElementClass [
	^ OPBPMNActivityShape
]

{ #category : 'accessing' }
OPBPMNActivityControllerTest >> modelClass [
	^ OPBPMNActivityModel 
]
