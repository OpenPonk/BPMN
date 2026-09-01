"
I am a unit test class verifying the creation, attachment, and diagram targeting behavior of OPBPMNActivityController.
"
Class {
	#name : 'OPBPMNActivityControllerTest',
	#superclass : 'OPBPMNSemanticNodeControllerTest',
	#category : 'OpenPonk-BPMN-Tests',
	#package : 'OpenPonk-BPMN',
	#tag : 'Tests'
}

{ #category : 'constants' }
OPBPMNActivityControllerTest class >> diagramElementClass [
	^ OPBPMNActivityShape
]

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
OPBPMNActivityControllerTest >> modelClass [
	^ OPBPMNActivityModel 
]
