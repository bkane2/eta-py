
.. toctree::
   :hidden:

   Home page <self>
   Eta documentation <_autosummary/eta>

Eta Dialogue Manager Documentation
==================================

.. image:: _static/figures/architecture.png

This is the official Python implementation of the Eta Dialogue Manager, a general-purpose and extensible framework for
creating intelligent conversational agents from **dialogue schemas** that represent expected dialogue events within a
particular domain. The dialogue manager interleaves four parallel processes, each of which operate on a shared dialogue state:

   - perception
   - reasoning
   - planning
   - execution

The specific functionality of each process can be modified through the use of modular **transducers** that perform a specific type of
data mapping (e.g., mapping input utterances to semantic representations, or mapping a dialogue plan to a new expanded dialogue plan).
Each type of transducer is implementation-agnostic, allowing for the substitution of many possible models for each type of mapping
function; whether symbolic rules, a neural network, a large language model API, or some combination thereof. The modified data is
processed using a set of task buffers (priority queues) in order to ensure consistency between processes.

Eta is also representationally flexible, allowing for multiple levels of knowledge representation for events in
schemas and memory. All of these three levels are encapsulated by the notion of an **eventuality**, which represents an
abstract fact or event with an associated representation.

Use the sidebar to browse the documentation for Eta.

