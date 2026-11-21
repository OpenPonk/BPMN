"
Verifies structural containment, lane management, and element lifecycle operations within BPMN pool models.
"
Class {
	#name : 'OPBPMNPoolModelTest',
	#superclass : 'TestCase',
	#category : 'OpenPonk-BPMN-Tests-Models',
	#package : 'OpenPonk-BPMN-Tests',
	#tag : 'Models'
}

{ #category : 'tests' }
OPBPMNPoolModelTest >> testAddLaneBeforeAndAfter [
	| poolModel firstLane secondLane thirdLane fourthLane |
	poolModel := OPBPMNPoolModel new.
	firstLane := OPBPMNLaneModel new name: 'Lane 1'.
	secondLane := OPBPMNLaneModel new name: 'Lane 2'.
	thirdLane := OPBPMNLaneModel new name: 'Lane 3'.
	fourthLane := OPBPMNLaneModel new name: 'Lane 4'.
	poolModel addLane: firstLane.
	poolModel addLane: secondLane.
	poolModel addLane: thirdLane before: secondLane.
	self assert: (poolModel lanes collect: [ :eachLane | eachLane name ]) asArray equals: #('Lane 1' 'Lane 3' 'Lane 2').
	poolModel addLane: fourthLane after: firstLane.
	self assert: (poolModel lanes collect: [ :eachLane | eachLane name ]) asArray equals: #('Lane 1' 'Lane 4' 'Lane 3' 'Lane 2')
]

{ #category : 'tests' }
OPBPMNPoolModelTest >> testAddLaneBeforeAndAfterIgnoresDuplicates [

	| poolModel firstLane secondLane |
	poolModel := OPBPMNPoolModel new.
	firstLane := OPBPMNLaneModel new name: 'Lane 1'.
	secondLane := OPBPMNLaneModel new name: 'Lane 2'.
	poolModel
		addLane: firstLane;
		addLane: secondLane.

	self assert: (poolModel addLane: firstLane before: secondLane) identicalTo: firstLane.
	self assert: (poolModel addLane: secondLane after: firstLane) identicalTo: secondLane.
	self assert: (poolModel lanes collect: #name as: Array) equals: #( 'Lane 1' 'Lane 2' )
]

{ #category : 'tests' }
OPBPMNPoolModelTest >> testLaneForReturnsNilWhenNodeNotInAnyLane [

	| poolModel laneModel outsideTask |
	poolModel := OPBPMNPoolModel new name: 'Pool'.
	laneModel := OPBPMNLaneModel new name: 'Lane 1'.
	outsideTask := OPBPMNActivityModel new name: 'Outside'.
	poolModel addLane: laneModel.

	self assert: (poolModel laneFor: outsideTask) identicalTo: nil
]
