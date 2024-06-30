Class {
	#name : 'OPBPMNDataObjectTest',
	#superclass : 'OPBPMNNodeControllerTest',
	#category : 'OpenPonk-BPMN-Tests',
	#package : 'OpenPonk-BPMN',
	#tag : 'Tests'
}

{ #category : 'accessing' }
OPBPMNDataObjectTest >> controllerClass [
	^ OPBPMNDataObjectController  
]

{ #category : 'accessing' }
OPBPMNDataObjectTest >> creationTargetControllerClass [
	^ OPBPMNPoolController    
]

{ #category : 'accessing' }
OPBPMNDataObjectTest >> creationTargetModelClass [
	^ OPBPMNPoolModel 
]

{ #category : 'accessing' }
OPBPMNDataObjectTest >> diagramElementClass [
	^ OPBPMNDataObjectShape 
]

{ #category : 'accessing' }
OPBPMNDataObjectTest >> modelClass [
	^ OPBPMNDataObjectModel 
]
