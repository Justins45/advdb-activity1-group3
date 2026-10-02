# advdb-activity1-group3
# Design process and modelling tool
Our group designed a logical database model to manage the operations of a local gym. We identified the main entities based on the business requirements and used LucidChart to create our EERD diagram. We used a partial, disjoint specialization for the Staff and Trainer entities, resolving many to many relationships using the associative booking entity.

# Business Rules
- **Class Scheduling**: Each class can be in zero to many scheduled classes. Each scheduled class can only be lined to one class.
- **Trainer Assignment**: Each Trainer can be in zero to many scheduled classes. Each scheduled class can only have one trainer
- **Bookings**: Each booking is for one scheduled class. Each scheduled class can have zero to many bookings.
- **Member bookings**: Each member can have zero to many bookings. Each booking is linked to one member.
- **Payments**: Each member can have one to many payments. Each payment is linked to one member.


# Assumptions and Normalizations (Up to 3NF)
- *Staff* and *Trainer* is partial, disjoint because staff can be or not be a trainer.
- Both a member and staff can only have one email and phone number (1NF).
- Payments are reoccurring monthly, which a member can cancel or pause. By separating *payment_details* into a *payment* table and storing *payment_method* in the *member* table, we got rid of transitive dependencies (3NF).

