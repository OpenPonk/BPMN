Class {
	#name : 'OPBPMNDataFlowControllerTest',
	#superclass : 'OPBPMNEdgeControllerTest',
	#category : 'OpenPonk-BPMN-Tests',
	#package : 'OpenPonk-BPMN',
	#tag : 'Tests'
}

{ #category : 'accessing' }
OPBPMNDataFlowControllerTest >> controllerClass [
	^ OPBPMNDataFlowController
]

{ #category : 'accessing' }
OPBPMNDataFlowControllerTest >> diagramElementClass [

	^ OPBPMNDataFlowShape 
]

{ #category : 'accessing' }
OPBPMNDataFlowControllerTest >> modelClass [
	^ OPBPMNDataFlowModel 
]

{ #category : 'accessing' }
OPBPMNDataFlowControllerTest >> sourceControllerClass [
	^ OPBPMNDataObjectController  
]

{ #category : 'accessing' }
OPBPMNDataFlowControllerTest >> sourceModelClass [
	^ OPBPMNDataObjectModel 
]
