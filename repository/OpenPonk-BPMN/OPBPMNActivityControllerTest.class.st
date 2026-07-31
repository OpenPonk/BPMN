Class {
	#name : 'OPBPMNActivityControllerTest',
	#superclass : 'OPBPMNSemanticNodeControllerTest',
	#category : 'OpenPonk-BPMN-Tests',
	#package : 'OpenPonk-BPMN',
	#tag : 'Tests'
}

{ #category : 'constants' }
OPBPMNActivityControllerTest >> controllerClass [
	^ OPBPMNActivityController 
]

{ #category : 'constants' }
OPBPMNActivityControllerTest >> creationTargetControllerClass [
	^ OPBPMNPoolController  
]

{ #category : 'constants' }
OPBPMNActivityControllerTest >> creationTargetModelClass [
	^ OPBPMNPoolModel 
]

{ #category : 'constants' }
OPBPMNActivityControllerTest >> diagramElementClass [
	^ OPBPMNActivityShape
]

{ #category : 'constants' }
OPBPMNActivityControllerTest >> modelClass [
	^ OPBPMNActivityModel 
]
