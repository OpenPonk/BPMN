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
OPBPMNGatewayControllerTest >> creationTargetControllerClass [
	^ OPBPMNPoolController  
]

{ #category : 'accessing' }
OPBPMNGatewayControllerTest >> creationTargetModelClass [
	^ OPBPMNPoolModel 
]

{ #category : 'accessing' }
OPBPMNGatewayControllerTest >> diagramElementClass [
	^ OPBPMNGatewayShape
]

{ #category : 'accessing' }
OPBPMNGatewayControllerTest >> modelClass [
	^ OPBPMNGatewayModel 
]
