Class {
	#name : 'OPBPMNGatewayControllerTest',
	#superclass : 'OPBPMNNodeControllerTest',
	#category : 'OpenPonk-BPMN-Tests',
	#package : 'OpenPonk-BPMN',
	#tag : 'Tests'
}

{ #category : 'accessing' }
OPBPMNGatewayControllerTest >> controllerClass [
	^ OPBPMNGatewayController 
]

{ #category : 'accessing' }
OPBPMNGatewayControllerTest >> diagramElementClass [
	^ OPBPMNGatewayShape
]

{ #category : 'accessing' }
OPBPMNGatewayControllerTest >> modelClass [
	^ OPBPMNGatewayModel 
]

{ #category : 'accessing' }
OPBPMNGatewayControllerTest >> targetControllerClass [
	^ OPBPMNPoolController  
]

{ #category : 'accessing' }
OPBPMNGatewayControllerTest >> targetModelClass [
	^ OPBPMNPoolModel 
]
