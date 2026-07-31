Class {
	#name : 'OPBPMNSubProcessControllerTest',
	#superclass : 'OPBPMNSemanticNodeControllerTest',
	#category : 'OpenPonk-BPMN-Tests',
	#package : 'OpenPonk-BPMN',
	#tag : 'Tests'
}

{ #category : 'constants' }
OPBPMNSubProcessControllerTest >> controllerClass [
	^ OPBPMNSubProcessController 
]

{ #category : 'constants' }
OPBPMNSubProcessControllerTest >> creationTargetControllerClass [
	^ OPBPMNPoolController  
]

{ #category : 'constants' }
OPBPMNSubProcessControllerTest >> creationTargetModelClass [
	^ OPBPMNPoolModel 
]

{ #category : 'constants' }
OPBPMNSubProcessControllerTest >> diagramElementClass [
	^ OPBPMNSubProcessShape 
]

{ #category : 'constants' }
OPBPMNSubProcessControllerTest >> modelClass [
	^ OPBPMNSubProcessModel 
]
