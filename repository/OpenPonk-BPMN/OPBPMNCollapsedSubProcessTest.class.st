Class {
	#name : 'OPBPMNCollapsedSubProcessTest',
	#superclass : 'OPBPMNNodeControllerTest',
	#category : 'OpenPonk-BPMN-Tests',
	#package : 'OpenPonk-BPMN',
	#tag : 'Tests'
}

{ #category : 'accessing' }
OPBPMNCollapsedSubProcessTest >> controllerClass [
	^ OPBPMNCollapsedSubProcessController  
]

{ #category : 'accessing' }
OPBPMNCollapsedSubProcessTest >> creationTargetControllerClass [
	^ OPBPMNPoolController  
]

{ #category : 'accessing' }
OPBPMNCollapsedSubProcessTest >> creationTargetModelClass [
	^ OPBPMNPoolModel 
]

{ #category : 'accessing' }
OPBPMNCollapsedSubProcessTest >> diagramElementClass [
	^ OPBPMNCollapsedSubProcessShape 
]

{ #category : 'accessing' }
OPBPMNCollapsedSubProcessTest >> modelClass [
	^ OPBPMNCollapsedSubProcessModel 
]
