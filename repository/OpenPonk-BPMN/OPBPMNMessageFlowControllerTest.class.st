Class {
	#name : #OPBPMNMessageFlowControllerTest,
	#superclass : #OPBPMNFlowControllerTest,
	#category : #'OpenPonk-BPMN-Tests'
}

{ #category : #accessing }
OPBPMNMessageFlowControllerTest >> controllerClass [
	^ OPBPMNMessageFlowController
]

{ #category : #accessing }
OPBPMNMessageFlowControllerTest >> modelClass [
	^ OPBPMNMessageFlowModel 
]

{ #category : #accessing }
OPBPMNMessageFlowControllerTest >> testCreateFigure [
	| figure previousElementsSize |
	controller
		source: fromCtrl;
		target: toCtrl;
		model: model.
	diagramController addController: controller.
	previousElementsSize := diagramController view elements size.
	figure := controller renderFigureIn: diagramController view.
	self assert: figure class equals: RTEdge.
	self assert: figure from equals: fromCtrl figure.
	self assert: figure to equals: toCtrl figure.
	self
		assert: diagramController view elements size
		equals: previousElementsSize + 1.
	self assert: (figure shape isKindOf: RTStyledMultiLine).
	self assert: figure shape color equals: Color black.
	self assert: figure shape head shape equals: RTSimpleArrow.
	self assert: figure shape dashes isNotNil
]

{ #category : #accessing }
OPBPMNMessageFlowControllerTest >> testCreateModel [
	| createdModel |
	controller source: fromCtrl.
	controller target: toCtrl.
	fromCtrl createModelIn: diagramController model.
	toCtrl createModelIn: diagramController model.
	createdModel := controller createModelIn: diagramController model.
	self assert: createdModel class equals: self modelClass.
	self assert: createdModel source equals: fromCtrl model.
	self assert: createdModel target equals: toCtrl model
]

{ #category : #accessing }
OPBPMNMessageFlowControllerTest >> testFigureRefresh [
	| label |
	controller
		source: fromCtrl;
		target: toCtrl.
	diagramController addController: controller.
	controller createModelIn: diagramController model.
	controller renderFigureIn: diagramController view.
	label := controller figure labels at: #name.
	self assert: label trachelShape text equals: ''.
	controller model name: 'new name'.
	controller refreshFigure.
	self assert: label trachelShape text equals: 'new name'
]
