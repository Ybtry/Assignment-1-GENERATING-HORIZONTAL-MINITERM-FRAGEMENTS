import itertools

class MinitermFragmentGenerator:
    def __init__(self, predicates):
        self.predicates = predicates
     
    def generate_miniterms(self):
        # Generate all possible combinations of True/False values for each predicate
        combinations = list(itertools.product([True, False], repeat=len(self.predicates)))
        
        # Map combinations to predicates
        miniterms = []
        for combo in combinations:
            miniterm = {pred: value for pred, value in zip(self.predicates, combo)}
            miniterms.append(miniterm)
        
        return miniterms

# Example usage
predicates = ['P1', 'P2', 'P3']
generator = MinitermFragmentGenerator(predicates)
miniterms = generator.generate_miniterms()

for i, miniterm in enumerate(miniterms, start=1):
    print(f"Miniterm {i}: {miniterm}")