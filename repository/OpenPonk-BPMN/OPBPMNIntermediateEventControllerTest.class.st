Class {
	#name : 'OPBPMNIntermediateEventControllerTest',
	#superclass : 'OPBPMNSemanticNodeControllerTest',
	#category : 'OpenPonk-BPMN-Tests',
	#package : 'OpenPonk-BPMN',
	#tag : 'Tests'
}

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
OPBPMNIntermediateEventControllerTest >> diagramElementClass [
	^ OPBPMNIntermediateEventShape
]

{ #category : 'constants' }
OPBPMNIntermediateEventControllerTest >> modelClass [
	^ OPBPMNIntermediateEventModel 
]
