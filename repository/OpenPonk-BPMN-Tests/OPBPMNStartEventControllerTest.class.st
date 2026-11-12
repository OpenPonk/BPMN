"
I am a unit test class verifying the creation, canvas rendering, and diagram targeting behavior of OPBPMNStartEventController.
"
Class {
	#name : 'OPBPMNStartEventControllerTest',
	#superclass : 'OPBPMNSemanticNodeControllerTest',
	#category : 'OpenPonk-BPMN-Tests-Controllers',
	#package : 'OpenPonk-BPMN-Tests',
	#tag : 'Controllers'
}

{ #category : 'constants' }
OPBPMNStartEventControllerTest class >> diagramElementClass [
	^ OPBPMNStartEventShape 
]

{ #category : 'constants' }
OPBPMNStartEventControllerTest >> controllerClass [
	^ OPBPMNStartEventController 
]

{ #category : 'constants' }
OPBPMNStartEventControllerTest >> creationTargetControllerClass [
	^ OPBPMNPoolController  
]

{ #category : 'constants' }
OPBPMNStartEventControllerTest >> creationTargetModelClass [
	^ OPBPMNPoolModel 
]

{ #category : 'constants' }
OPBPMNStartEventControllerTest >> modelClass [
	^ OPBPMNStartEventModel 
]
