Class {
	#name : 'OPBPMNMessageFlowControllerTest',
	#superclass : 'OPBPMNEdgeControllerTest',
	#category : 'OpenPonk-BPMN-Models',
	#package : 'OpenPonk-BPMN',
	#tag : 'Models'
}

{ #category : 'accessing' }
OPBPMNMessageFlowControllerTest >> controllerClass [
	^ OPBPMNMessageFlowController
]

{ #category : 'constants' }
OPBPMNMessageFlowControllerTest >> diagramElementClass [

	^ OPBPMNMessageFlowShape 
]

{ #category : 'accessing' }
OPBPMNMessageFlowControllerTest >> modelClass [
	^ OPBPMNMessageFlowModel 
]

{ #category : 'constants' }
OPBPMNMessageFlowControllerTest >> sourceControllerClass [
	^ OPBPMNPoolController  
]

{ #category : 'constants' }
OPBPMNMessageFlowControllerTest >> sourceModelClass [
	^ OPBPMNPoolModel 
]
