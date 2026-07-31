Class {
	#name : 'OPBPMNCollapsedSubProcessControllerTest',
	#superclass : 'OPBPMNSemanticNodeControllerTest',
	#category : 'OpenPonk-BPMN-Tests',
	#package : 'OpenPonk-BPMN',
	#tag : 'Tests'
}

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
OPBPMNCollapsedSubProcessControllerTest >> diagramElementClass [
	^ OPBPMNCollapsedSubProcessShape 
]

{ #category : 'constants' }
OPBPMNCollapsedSubProcessControllerTest >> modelClass [
	^ OPBPMNCollapsedSubProcessModel 
]
