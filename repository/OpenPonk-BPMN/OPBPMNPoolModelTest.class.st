Class {
	#name : 'OPBPMNPoolModelTest',
	#superclass : 'TestCase',
	#category : 'OpenPonk-BPMN-Tests',
	#package : 'OpenPonk-BPMN',
	#tag : 'Tests'
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
