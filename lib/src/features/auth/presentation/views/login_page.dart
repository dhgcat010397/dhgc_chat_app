part of 'auth_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, this.onTap});

  final VoidCallback? onTap;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late FocusNode _emailFocusNode;
  late FocusNode _passwordFocusNode;

  @override
  void initState() {
    super.initState();

    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _emailFocusNode = FocusNode();
    _passwordFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      extendBodyBehindAppBar: true,
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            padding: const EdgeInsets.symmetric(
              vertical: 15.0,
              horizontal: 30.0,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10.0,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Login Page Content'),
                  const SizedBox(height: 20),
                  _buildEmailField(),
                  const SizedBox(height: 20),
                  _buildPasswordField(),
                  const SizedBox(height: 20),
                  AuthButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        // Handle login action
                      }
                    },
                  ),
                  const SizedBox(height: 20),
                  _buildRegisterButton(),
                  const SizedBox(height: 10),
                  TextDivider(),
                  const SizedBox(height: 10),
                  GoogleLoginButton(
                    onPressed: () {
                      // Handle Google sign-in action
                      context.read<AuthBloc>().add(AuthEvent.loginWithGoogle());
                    },
                  ),
                  const SizedBox(height: 10),
                  FacebookLoginButton(
                    onPressed: () {
                      // Handle Facebook sign-in action
                    },
                  ),
                  const SizedBox(height: 10),
                  AppleLoginButton(
                    onPressed: () {
                      // Handle Apple sign-in action
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      controller: _emailController,
      focusNode: _emailFocusNode,
      validator: InputValidator.validateEmail,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        labelText: 'Email',
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget _buildPasswordField() {
    return PasswordTextField(
      controller: _passwordController,
      focusNode: _passwordFocusNode,
      validator: InputValidator.validatePassword,
    );
  }

  Widget _buildRegisterButton() {
    return Text.rich(
      TextSpan(
        text: 'Don\'t have an account? ',
        style: const TextStyle(color: Colors.black54),
        children: [
          TextSpan(
            text: 'Register',
            style: const TextStyle(
              color: AppColors.primaryColor,
              fontWeight: FontWeight.bold,
            ),
            recognizer: TapGestureRecognizer()..onTap = widget.onTap,
          ),
        ],
      ),
    );
  }
}
