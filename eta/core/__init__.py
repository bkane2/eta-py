"""Eta Core

Contains the main Eta executable, as well as each of the core processes of Eta 
that run in parallel.

Modules
-------
eta : Definition of Eta dialogue state, and executable main method.
perception : The process responsible for perceiving and interpreting inputs and adding them to memory.
reasoning : The process responsible for making inferences from schemas and memory.
planning : The process responsible for using schemas and memory to update plan.
execution : The process responsible for executing primitive actions and matching expected events to memory.
"""