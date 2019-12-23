int main() {
	int a[5] = {1, -20, 3, -4, 5};
	int min_val;
	int i;
	min_val = a[0];

		for(i = 1; i < 5; i++)
		{
			int b = a[i];
			if(b < min_val)
			{
				min_val = b;
			}
		}
	return min_val;
}
