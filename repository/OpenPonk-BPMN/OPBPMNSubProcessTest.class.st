Class {
	#name : 'OPBPMNSubProcessTest',
	#superclass : 'OPBPMNNodeControllerTest',
	#category : 'OpenPonk-BPMN-Tests',
	#package : 'OpenPonk-BPMN',
	#tag : 'Tests'
}

{ #category : 'accessing' }
OPBPMNSubProcessTest >> controllerClass [
	^ OPBPMNSubProcessController 
]

{ #category : 'accessing' }
OPBPMNSubProcessTest >> creationTargetControllerClass [
	^ OPBPMNPoolController  
]

{ #category : 'accessing' }
OPBPMNSubProcessTest >> creationTargetModelClass [
	^ OPBPMNPoolModel 
]

{ #category : 'accessing' }
OPBPMNSubProcessTest >> diagramElementClass [
	^ OPBPMNSubProcessShape 
]

{ #category : 'accessing' }
OPBPMNSubProcessTest >> modelClass [
	^ OPBPMNSubProcessModel 
]
