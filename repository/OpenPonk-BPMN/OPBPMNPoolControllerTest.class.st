Class {
	#name : 'OPBPMNPoolControllerTest',
	#superclass : 'OPBPMNNodeControllerTest',
	#category : 'OpenPonk-BPMN-Tests',
	#package : 'OpenPonk-BPMN',
	#tag : 'Tests'
}

{ #category : 'accessing' }
OPBPMNPoolControllerTest >> controllerClass [
	^ OPBPMNPoolController 
]

{ #category : 'accessing' }
OPBPMNPoolControllerTest >> diagramElementClass [
	^ OPBPMNPoolShape
]

{ #category : 'accessing' }
OPBPMNPoolControllerTest >> modelClass [
	^ OPBPMNPoolModel 
]

{ #category : 'accessing' }
OPBPMNPoolControllerTest >> testAssignmentToParent [
	"not by pool"
]

{ #category : 'accessing' }
OPBPMNPoolControllerTest >> testFigureRefresh [

	| text |
	controller createModelIn: diagramController model.
	diagramController addController: controller.
	controller
		createDiagramElement;
		renderDiagramElement.
	self assert: controller diagramElement label text = ''.
	controller model name: 'new name'.
	controller modelChanged.
	text := controller diagramElement label text.
	self assert:
		((text last: 8) = 'new name' or: [ (text first: 8) = 'new name' ])
]
