extern int MAX_2(int x, int y);

		int main() {
			int lst[10] = {1, 67, 69, 23, 54, 12, 89, 32, 101, 324};
			
			int i;
			int max = lst[0];			

			for (i = 1; i < 10; i++)
			{
				int b = lst[i];
				max = MAX_2(max,b);
			}
			return max;
}
