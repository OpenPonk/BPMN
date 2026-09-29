"
I am a unit test class verifying the creation, canvas rendering, and valid connection targeting of OPBPMNCollapsedSubProcessController.
"
Class {
	#name : 'OPBPMNCollapsedSubProcessControllerTest',
	#superclass : 'OPBPMNSemanticNodeControllerTest',
	#category : 'OpenPonk-BPMN-Tests',
	#package : 'OpenPonk-BPMN',
	#tag : 'Tests'
}

{ #category : 'constants' }
OPBPMNCollapsedSubProcessControllerTest class >> diagramElementClass [
	^ OPBPMNCollapsedSubProcessShape 
]

{ #category : 'constants' }
OPBPMNCollapsedSubProcessControllerTest >> controllerClass [
	^ OPBPMNCollapsedSubProcessController  
]

{ #category : 'constants' }
OPBPMNCollapsedSubProcessControllerTest >> creationTargetControllerClass [
	^ OPBPMNPoolController  
]

{ #category : 'constants' }
OPBPMNCollapsedSubProcessControllerTest >> creationTargetModelClass [
	^ OPBPMNPoolModel 
]

{ #category : 'constants' }
OPBPMNCollapsedSubProcessControllerTest >> modelClass [
	^ OPBPMNCollapsedSubProcessModel 
]
