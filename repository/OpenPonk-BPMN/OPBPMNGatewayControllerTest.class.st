Class {
	#name : 'OPBPMNGatewayControllerTest',
	#superclass : 'OPBPMNSemanticNodeControllerTest',
	#category : 'OpenPonk-BPMN-Tests',
	#package : 'OpenPonk-BPMN',
	#tag : 'Tests'
}

{ #category : 'constants' }
OPBPMNGatewayControllerTest >> controllerClass [
	^ OPBPMNGatewayController 
]

{ #category : 'constants' }
OPBPMNGatewayControllerTest >> creationTargetControllerClass [
	^ OPBPMNPoolController  
]

{ #category : 'constants' }
OPBPMNGatewayControllerTest >> creationTargetModelClass [
	^ OPBPMNPoolModel 
]

{ #category : 'constants' }
OPBPMNGatewayControllerTest >> diagramElementClass [
	^ OPBPMNGatewayShape
]

{ #category : 'constants' }
OPBPMNGatewayControllerTest >> modelClass [
	^ OPBPMNGatewayModel 
]
