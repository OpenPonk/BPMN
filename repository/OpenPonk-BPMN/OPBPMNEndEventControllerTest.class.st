"
I am a unit test class verifying the creation, canvas rendering, and diagram targeting behavior of OPBPMNEndEventController.
"
Class {
	#name : 'OPBPMNEndEventControllerTest',
	#superclass : 'OPBPMNSemanticNodeControllerTest',
	#category : 'OpenPonk-BPMN-Tests',
	#package : 'OpenPonk-BPMN',
	#tag : 'Tests'
}

{ #category : 'constants' }
OPBPMNEndEventControllerTest class >> diagramElementClass [

	^ OPBPMNEndEventShape 
]

{ #category : 'constants' }
OPBPMNEndEventControllerTest >> controllerClass [
	^ OPBPMNEndEventController 
]

{ #category : 'constants' }
OPBPMNEndEventControllerTest >> creationTargetControllerClass [
	^ OPBPMNPoolController  
]

{ #category : 'constants' }
OPBPMNEndEventControllerTest >> creationTargetModelClass [
	^ OPBPMNPoolModel
]

{ #category : 'constants' }
OPBPMNEndEventControllerTest >> modelClass [
	^ OPBPMNEndEventModel 
]
