"
I am a unit test class verifying the creation, canvas rendering, and diagram targeting behavior of OPBPMNGatewayController.
"
Class {
	#name : 'OPBPMNGatewayControllerTest',
	#superclass : 'OPBPMNSemanticNodeControllerTest',
	#category : 'OpenPonk-BPMN-Tests',
	#package : 'OpenPonk-BPMN',
	#tag : 'Tests'
}

{ #category : 'constants' }
OPBPMNGatewayControllerTest class >> diagramElementClass [
	^ OPBPMNGatewayShape
]

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
OPBPMNGatewayControllerTest >> modelClass [
	^ OPBPMNGatewayModel 
]
