"
I am a unit test class verifying the creation, canvas rendering, and diagram targeting behavior of OPBPMNIntermediateEventController.
"
Class {
	#name : 'OPBPMNIntermediateEventControllerTest',
	#superclass : 'OPBPMNSemanticNodeControllerTest',
	#category : 'OpenPonk-BPMN-Tests',
	#package : 'OpenPonk-BPMN',
	#tag : 'Tests'
}

{ #category : 'constants' }
OPBPMNIntermediateEventControllerTest class >> diagramElementClass [
	^ OPBPMNIntermediateEventShape
]

{ #category : 'constants' }
OPBPMNIntermediateEventControllerTest >> controllerClass [
	^ OPBPMNIntermediateEventController 
]

{ #category : 'constants' }
OPBPMNIntermediateEventControllerTest >> creationTargetControllerClass [
	^ OPBPMNPoolController  
]

{ #category : 'constants' }
OPBPMNIntermediateEventControllerTest >> creationTargetModelClass [
	^ OPBPMNPoolModel 
]

{ #category : 'constants' }
OPBPMNIntermediateEventControllerTest >> modelClass [
	^ OPBPMNIntermediateEventModel 
]
