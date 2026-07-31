Class {
	#name : 'OPBPMNEndEventControllerTest',
	#superclass : 'OPBPMNSemanticNodeControllerTest',
	#category : 'OpenPonk-BPMN-Tests',
	#package : 'OpenPonk-BPMN',
	#tag : 'Tests'
}

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
OPBPMNEndEventControllerTest >> diagramElementClass [

	^ OPBPMNEndEventShape 
]

{ #category : 'constants' }
OPBPMNEndEventControllerTest >> modelClass [
	^ OPBPMNEndEventModel 
]
