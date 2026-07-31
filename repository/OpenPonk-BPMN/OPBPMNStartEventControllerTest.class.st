Class {
	#name : 'OPBPMNStartEventControllerTest',
	#superclass : 'OPBPMNSemanticNodeControllerTest',
	#category : 'OpenPonk-BPMN-Tests',
	#package : 'OpenPonk-BPMN',
	#tag : 'Tests'
}

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
OPBPMNStartEventControllerTest >> diagramElementClass [
	^ OPBPMNStartEventShape 
]

{ #category : 'constants' }
OPBPMNStartEventControllerTest >> modelClass [
	^ OPBPMNStartEventModel 
]
