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
OPBPMNDataObjectTest >> diagramElementClass [
	^ OPBPMNDataObjectShape 
]

{ #category : 'accessing' }
OPBPMNDataObjectTest >> modelClass [
	^ OPBPMNDataObjectModel 
]

{ #category : 'accessing' }
OPBPMNDataObjectTest >> targetControllerClass [
	^ OPBPMNPoolController    
]

{ #category : 'accessing' }
OPBPMNDataObjectTest >> targetModelClass [
	^ OPBPMNPoolModel 
]
